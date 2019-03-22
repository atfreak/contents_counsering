$(window).on 'load', ->
  $('#loader').delay(900).fadeOut(900)
  $('#loading_ani').delay(600).fadeOut(300)
  graph.initialize()

window.graph =
  point:
    cute:
      localStorage.getItem 'cute'
    beautiful:
      localStorage.getItem 'beautiful'
    durability:
      localStorage.getItem 'durability'
    reproduction:
      localStorage.getItem 'reproduction'
  ticks:
    min: 0
    max: 100
    
  initialize: ->
    for key, value of @point
      if value >= 100
        @ticks.min = 20
        @ticks.max = 120
    #端末を縦で見るとき
    @setWindowSize()
    @setNotSideView()
    $(window).on 'resize', ->
      self.setNotSideView()
      self.setWindowSize()
    @setYourName()
    #グラフの背景を指定
    Chart.plugins.register
      beforeDraw: (c) ->
        ctx = c.chart.ctx
        ctx.fillStyle = "rgba(0, 0, 0, 0)"
        ctx.fillRect(0, 0, c.chart.width, c.chart.height)
    @drawGraph()
    self = @
    localStorage.clear()

  setNotSideView: ->
    w_height = $(window).height()
    if w_height <= 800
      $('.name-wrap').css 'top', '12%' 
      $('#downloadImageButton').css 'bottom', '17%' 
    else
      $('.name-wrap').css 'top', '29%' 
      $('#downloadImageButton').css 'bottom', '32%' 
    
  setWindowSize: ->
    set_w_height = $(window).height()
    $('.contents-wrap').css 'height', set_w_height

  setYourName: ->
    $('.name-wrap .name-text').text localStorage.getItem 'yourname'

  drawGraph: ->
    ctx = document.getElementById('myChart')
    myChart = new Chart ctx,
      type: 'radar'
      data:
        labels: ['', '', '', '']
        datasets: [
          label: ''
          backgroundColor: 'rgba(231,128,171,0.7)'
          borderColor: '#db498a'
          borderSize: 'bold'
          borderWidth: 3
          pointBorderWidth: 7
          pointBackgroundColor: '#db498a'
          data: [
            @point.cute,
            @point.beautiful,
            @point.durability,
            @point.reproduction
          ]
        ]
      options:
        responsive: true
        legend: {
          display: false
        }
        scale:
          ticks:
            min: @ticks.min
            max: @ticks.max
            stepSize: 20
            fontSize: 20
        chartArea:
          backgroundColor: '#000'