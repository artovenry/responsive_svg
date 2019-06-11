import {mapState, mapGetters} from "vuex"

export default
  components:
    Morphing:
      render: (h)->
        <animate begin="beginEvent" attributeName="d" from={CUBE} to={CIRCLE} />
      mounted: ->@$el.beginElement()
    Move:
      render: (h)->
        <animateMotion begin="beginEvent" onEndEvent={=>@$emit("finish")}>
          {@$slots.default}
        </animateMotion>
      mounted: ->@$el.beginElement()
  props: ["position"]
  data: ->animationFinished: no
  computed: {
    mapState(["animating", "drop"])...
    mapGetters(["origin"])...
  }
  render: (h)->
    WIDTH= @drop.width;D= @drop.width + @drop.margin
    <g
      transform={
        if @animationFinished
          """
            translate(#{@origin.end.x} #{@origin.end.y})
            translate(-#{WIDTH / 2} -#{WIDTH / 2})
          """
        else
          """
            translate(-#{D} #{D})
            translate(#{@origin.begin.x} #{@origin.begin.y})
          """
        + """
            translate(-#{WIDTH / 2} -#{WIDTH / 2})
        """
      }
    >
      <svg
        viewBox="0 0 2 2"
        onClick={=>@$store.commit "begin"}
        width={WIDTH} height={WIDTH}
      >
        <path stroke="none" d={if @animationFinished then CIRCLE else CUBE} fill="currentColor">
          {if @animating then <morphing dur="2s" fill="freeze" />}
        </path>
      </svg>
      {if @animating
        <move dur="2s" onFinish={=>@$store.commit "end";@animationFinished= yes}>
          <mpath href={"#mpath-#{8}"} />
        </move>
      }
    </g>
