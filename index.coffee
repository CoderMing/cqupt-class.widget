options = 
  studentID: 2016211603
  fontSize: '23px'    # 字体大小
  textAlign: 'left'
  fontWeight: 400
  opacity: 1
  dayChangeTime: 21  # 每日自动切换至下一天的课程的时间，按小时计，整数。合法值1-24

command: "/usr/local/bin/node cqupt-class.widget/req.txt #{options.studentID}"

render: -> """
  <div id='cquptClass'></div>
"""

refreshFrequency: 1000 * 60 * 60    # 每小时刷新一次

update: (output, domEl) -> 
  console.dir(output)
  if JSON.parse(output).success == false and JSON.parse(output).status != 200
    console.log('课程列表数据更新失败')
  else
    localStorage.setItem 'cl-data', output
  
  @$el = $(domEl)

  @data = JSON.parse localStorage.getItem 'cl-data'
  # 当前课程周
  reqWeek = @data.nowWeek
  # 当前时间
  dateObj = new Date()
  # 当前天数的中文字符
  dayChar = ['日', '一', '二', '三', '四', '五', '六', '日']
  # 今天是否有课
  isHaveClass = false
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
      <div class='title'>
        明日（#{if dateObj.getDay() == 0 then '下周' else ''}\
        周#{dayChar[dateObj.getDay() + 1]}）课程
      </div>
    """
  else
    domTemp += """
      <div class='title'>周#{dayChar[dateObj.getDay()]}</div>
    """
  # 计算出需要显示的正确日期 & 正确周
  if dateObj.getDay() == 0 and dayChange == 0
    reqWeek += 1
  
  if dateObj.getDay() == 0 and dayChange == 1
    reqDay = 6
  else 
    reqDay = dateObj.getDay() - dayChange

  # 列表渲染
  @data.data.forEach (el) ->
    if el.week.find((data) -> data == reqWeek) and el.hash_day == reqDay
      isHaveClass = true
      domTemp += """
        <div class='clItem'>
          <div class='cli-name'><span class='cli-time'>#{el.lesson}</span>#{el.course}</div>
          <div class='cli-room'>#{el.classroom}</div>
          <div class='cli-teacher'>
            <span class='cli-type'>#{el.type}</span>
            #{if el.period != 2 \
                then ('<span>' + el.teacher + '</span>' + el.period + '节连上') \
                else el.teacher}
          </div>
        </div>
      """

  if isHaveClass == false
    domTemp += """
        <div class='clItem'>
          <div class='cli-room'
               style='text-align: center'>
            #{if dayChange == 1 then '今' else '明'}日无课
          </div>
        </div>
    """
  
  @$el.find('#cquptClass').html domTemp



style: (->
  return """
    #{options.textAlign} 0
    top 0
    margin-#{options.textAlign} 100px
    margin-top 20px
    padding 10px 20px
    background rgba(0, 0, 0, 0)

    #cquptClass
      color white
      font-family -apple-system, BlinkMacSystemFont
      font-size #{options.fontSize}
      text-align center
      font-weight #{options.fontWeight}
      -webkit-font-smoothing antialiased
      -webkit-text-size-adjust none
      opacity #{options.opacity}
      min-width #{options.fontSize} * 10
      text-shadow 0px 0px 10px #333

      .title
        font-size #{options.fontSize} * .7
        padding-bottom 10px
      
      .clItem
        padding 10px 15px
        border-top .5px solid rgba(#FFF, .8)
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
