class revd.Rev

  constructor: ( diff, parent = undefined ) ->

    @_diff = diff
    @_parent = parent

  reviseWithDiff: ( diff ) ->

    new Rev( diff, @ )

  reviseWithNew: ( newValue ) ->

    reviseWithDiff( jsondiffpatch.diff( apply(), newValue ) )

  apply: ->

    base = if @_parent then @_parent.apply() else {}
    jsondiffpatch.patch( base, @_diff )

  # For now, merge always succeeds, with conflicts resolved in favor of the
  # current revision and its ancestors. Conflict identification is over-inclusive:
  # A conflict occurs anytime the current revision and its ancestors modify the
  # same root properties of the object as the other revision and its ancestors.
  merge: ( other ) ->

    nca = nearestCommonAncestor()

    # If one revision is an ancesor of the other, the descendant is the trivially
    # merged revision
    if nca == @
      return other
    else if nca == other
      return @

    # Otherwise, compare this Rev and the other to their nearest common ancestor,
    # applying changes from the other branch that do not conflict with this branch
    ncaValue = nca.apply()
    diffVsNca = jsondiffpatch.diff( apply(), ncaValue )
    otherDiffVsNca = jsondiffpatch.diff( other.apply(), ncaValue )

    diff = {}
    for key, subdiff of otherDiffVsNca
      unless diffVsNca[key]?
        diff[key] = subdiff

    reviseWithDiff( diff )

  nearestCommonAncestor: ( other ) ->

    ancestors = ancestors()
    otherAncestors = other.ancestors()

    for a in ancestors
      for oa in otherAncestors
        return a if a.equals(oa)

  ancestors: ->

    ancestors = []
    ancestor = @
    while ancestor?
      ancestors.push ancestor
      ancestor = ancestor._parent

    ancestors
