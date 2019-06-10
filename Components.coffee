import {mapState, mapGetters} from "vuex"

C= (4 / 3) * Math.tan(Math.PI / 8)
C1= (10 / 3) * Math.tan(Math.PI / 8)
CIRCLE="
  m 1 0
  c #{C} 0 1 #{1 - C} 1 1
  s #{C - 1} 1 -1 1
  s -1 #{C - 1} -1 -1
  s #{1 - C} -1 1 -1
"
CUBE="
  m 1 0
  c #{C1} 0 1 #{1 - C1} 1 1
  s #{C1 - 1} 1 -1 1
  s -1 #{C1 - 1} -1 -1
  s #{1 - C1} -1 1 -1
"

export default
  SymbolCircle:
    render: (h)->
      <symbol id="sym-circle" viewBox="0 0 2 2">
        <path stroke="none" d={CUBE} fill="currentColor" />
      </symbol>
  Drop:
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
    props: ["index"]
    data: ->animationFinished: no
    computed: {
      mapState(["animating", "drop"])...
      mapGetters(["origin"])...
    }
    render: (h)->
      WIDTH= @drop.width;D= @drop.width + @drop.margin
      <g
        transform={
          if @animating
            "translate(-#{WIDTH / 2} -#{WIDTH / 2})"
          else if @animationFinished
            """
              translate(#{@origin.end.x} #{@origin.end.y})
              translate(-#{WIDTH / 2} -#{WIDTH / 2})
            """
          else
            """
              translate(-#{D} #{D})
              translate(#{@origin.begin.x} #{@origin.begin.y})
              translate(-#{WIDTH / 2} -#{WIDTH / 2})
            """
        }
      >
        <svg
          viewBox="0 0 2 2"
          onClick={=>@$store.commit "begin"}
          width={WIDTH} height={WIDTH}
        >
          <path stroke="none" d={CUBE} fill="currentColor">
            {if @animating
              <morphing dur="2s" fill="freeze" />
            }
          </path>
        </svg>
        <path id="wine"
          d={"
            M #{@origin.begin.x} #{@origin.begin.y}
            m -#{D} #{D}
            L #{@origin.end.x} #{@origin.end.y}
          "}
          stroke-width="1" stroke="red"
        />
        {if @animating
          <move dur="2s" onFinish={=>@animationFinished= yes}>
            <mpath href="#wine" />
          </move>
        }
      </g>
