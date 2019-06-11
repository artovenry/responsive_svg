export default
  state:
    animating: off
    resizing: off
    svgWidth: 0, svgHeight:0, headerHeight: 0
    drop: width: 10, margin: 5
  getters:
    origin: (state)->
      begin:
        x: state.svgWidth / 2
        y: state.headerHeight / 2
      end:
        x: (state.svgWidth / 2) - (state.drop.width + state.drop.margin)
        y: state.svgHeight - (state.drop.width / 2  + state.drop.margin)

  mutations:
    begin: (state)->state.animating= on
    end:(state)->state.animating= off
    init: (state, data)->
      state.svgWidth= data.container.width
      state.svgHeight= data.container.height
      state.headerHeight= data.header.height
