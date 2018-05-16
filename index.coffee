options = 
  studentID: 2016211603
  fontSize: '30px'
  textAlign: 'center'

command: "/usr/local/bin/node cqupt-class.widget/req.txt #{options.studentID}"

render: -> """
  <div id='cquptClass'>
    <div class='nowWeek'>第十周</div>
    <div class='title'>周四</div>
    <div class='clItem'>
      <div class='cli-name'><span class='cli-time'>五六节</span>高等数学</div>
      <div class='cli-room'>计算机科学与技术重点实验室</div>
      <div class='cli-teacher'><span class='cli-type'>必修</span>么大大</div>
    </div>
  </div>
"""

refreshFrequency: 1000

update: (output, domEl) -> 
  @$el = $(domEl)

  if not localStorage.getItem 'cl-data'
    localStorage.setItem 'cl-data', output
  
  @data = JSON.parse localStorage.getItem 'cl-data'
  nowWeek = @data.nowWeek
  dayChar = new Date().getDay().toLocaleString('zh-Hans-CN-u-nu-hanidec')
  temp = @$el.find('.clItem').prop 'outerHTML'
  
  # 存dom内容
  domTemp = """
    <div class='nowWeek'>第#{@data.nowWeek}周</div>
    <div class='title'>周#{dayChar}</div>
  """

  @data.data.forEach (el) ->
    if el.week.find((data) -> data == nowWeek) and el.hash_day == new Date().getDay() - 1
      domTemp += """
        <div class='clItem'>
          <div class='cli-name'><span class='cli-time'>#{el.lesson}</span>#{el.course}</div>
          <div class='cli-room'>#{el.classroom}</div>
          <div class='cli-teacher'><span class='cli-type'>#{el.type}</span>#{el.teacher}</div>
        </div>
      """
  
  @$el.find('#cquptClass').html domTemp


style: (->
  return """
    #cquptClass
      margin-left 50vw
      margin-top 125px
      transform translateX(-50%)
      color white
      font-family -apple-system, BlinkMacSystemFont
      font-size #{options.fontSize}
      text-align center
      -webkit-font-smoothing antialiased
      -webkit-text-size-adjust none

      .title
        font-size #{options.fontSize} * .7
        padding-bottom 10px
      
      .clItem
        padding 5px 15px
        border-top 2px solid white
        text-align #{options.textAlign}
        line-height 1.1em
        span
          padding-right 8px
          border-right 1.5px solid white
          box-sizing border-box
          line-height .9em
          display inline-block
          margin-right 8px
        div
          height 1.2em
        .cli-name
          font-size #{options.fontSize} * .9
        .cli-room
          font-size #{options.fontSize} * .7
        .cli-teacher
          font-size #{options.fontSize} * .6
          padding-bottom 5px

  """
)()
