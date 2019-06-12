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
    when 1
      """
      """
    when 2
      """
      """
    when 3
      """
      """
    when 4
      """
      """
    when 5
      """
      """
    when 6
      """
      """
    when 7
      """
      """
    when 8
      """
      """

  return from + draw + to
