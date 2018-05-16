options = 
  studentID: 2016211603
  fontSize: '25px'
  textAlign: 'center'
  fontWeight: 400
  opacity: .9
  dayChangeTime: 21  # 每日自动切换至下一天的课程的时间，按小时计，整数。合法值1-24

command: "/usr/local/bin/node cqupt-class.widget/req.txt #{options.studentID}"

render: -> """
  <div id='cquptClass'></div>
"""

refreshFrequency: 1000 * 60 * 10    # 10min刷新一次

update: (output, domEl) -> 
  console.dir(output)
  if JSON.parse(output).success == false and JSON.parse(output).status != 200
    return false
  else
    localStorage.setItem 'cl-data', output
  
  @$el = $(domEl)

  @data = JSON.parse localStorage.getItem 'cl-data'
  # 当前课程周
  nowWeek = @data.nowWeek
  # 当前时间
  dateObj = new Date()
  # 当前天数的中文字符
  dayChar = ['日', '一', '二', '三', '四', '五', '六', '日']
  # 每天晚上9点后显示第二天的课程
  if dateObj.getHours() >= options.dayChangeTime - 1
    dayChange = 0
  else 
    dayChange = 1
  # 存 DOM 内容
  domTemp = """
    <div class='nowWeek'>第#{@data.nowWeek}周</div>
  """
  # 确定屏幕上显示的title
  if dayChange == 0
    domTemp += """
      <div class='title'>明日（周#{dayChar[dateObj.getDay() + 1]}）课程</div>
    """
  else
    domTemp += """
      <div class='title'>周#{dayChar[dateObj.getDay()]}</div>
    """
  # 计算出需要显示的正确日期
  if dateObj.getDay() == 0 and dayChange == 1
    reqDay = 6
  else 
    reqDay = dateObj.getDay() - dayChange
  # 列表渲染
  @data.data.forEach (el) ->
    if el.week.find((data) -> data == nowWeek) and el.hash_day == reqDay
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
      font-weight #{options.fontWeight}
      -webkit-font-smoothing antialiased
      -webkit-text-size-adjust none
      opacity #{options.opacity}

      .title
        font-size #{options.fontSize} * .7
        padding-bottom 10px
      
      .clItem
        padding 10px 15px
        border-top 1.5px solid white
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
          height 1.3em
        .cli-name
          font-size #{options.fontSize} * .9
        .cli-room
          font-size #{options.fontSize} * .7
        .cli-teacher
          font-size #{options.fontSize} * .6
          padding-bottom 5px
  """
)()
