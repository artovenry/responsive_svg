import figures from "./figures.coffee"
import {every} from "underscore"
import motionPath from "./motionPath.coffee"
[ON_GRID, ON_ANIMATING, ON_VERTICAL]= [0, 1, 2]

export default
  modules:
    animation:
      state: items: [0, 0, 0, 0, 0, 0, 0, 0, 0]
      getters:
        globalState: (state)->
          return ON_GRID if every state.items, (item)->item is ON_GRID
          return ON_VERTICAL if every state.items, (item)->item is ON_VERTICAL
          return ON_ANIMATING
        getState: (state, getters)->
          (index= null)->
            if index? then state.items[index] else getters.globalState
        onAnimating: (state, getters)->
          (index= null)->
            getters.getState(index) is ON_ANIMATING
        onGrid: (state, getters)->
          (index= null)->getters.getState(index) is ON_GRID
        onVertical: (state, getters)->
          (index= null)->
            getters.getState(index) is ON_VERTICAL
      mutations:
        # ここは非対称！
        toggleOn: (state)->state.items= [1, 1, 1, 1, 1, 1, 1, 1, 1]
        toggleOff: (state, data)->
          state.items.splice data.index, 1, (if data.direction is "vertical" then 2 else 0)
    layout:
      state:
        resizing: off
        svgWidth: 0, svgHeight:0, headerHeight: 0
      getters:
        origin: (state)->
          begin:
            x: state.svgWidth / 2
            y: state.headerHeight / 2
          end:
            x: (state.svgWidth / 2) - (figures.dropWidth + figures.grid.margin)
            y: state.svgHeight - (figures.dropWidth / 2  + figures.vertical.margin)
        gridDelta: (state, {origin})->
          (index)->
            gridUnit= figures.grid.margin + figures.dropWidth
            dx: origin.begin.x + gridUnit * figures.grid.drops[index][0]
            dy: origin.begin.y + gridUnit * figures.grid.drops[index][1]
        verticalDelta: (state, {origin})->
          (index)->
            verticalUnit= figures.vertical.margin + figures.dropWidth
            dx: origin.end.x
            dy: origin.end.y - verticalUnit * index
        motionPath: motionPath
      mutations:
        init: (state, data)->
          state.svgWidth= data.container.width
          state.svgHeight= data.container.height
          state.headerHeight= data.header.height
