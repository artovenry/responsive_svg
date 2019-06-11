export default (state, {origin, gridDelta, verticalDelta})->(index)->
  from= """
    M #{gridDelta(index).dx} #{gridDelta(index).dy}
  """

  to= """
    L #{verticalDelta(index).dx} #{verticalDelta(index).dy}
  """

  draw= switch index
    when 0
      """
      """

  return from + draw + to
