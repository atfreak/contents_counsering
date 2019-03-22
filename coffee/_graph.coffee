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
    min: 20
    max: 100
    
  initialize: ->
    for key, value of @point
      if value >= 100
        @ticks.min = 40
        @ticks.max = 120
    @setWindowSize()
    @setYourName()
    #グラフの背景を指定
    Chart.plugins.register
      beforeDraw: (c) ->
        ctx = c.chart.ctx
        ctx.fillStyle = "rgba(0, 0, 0, 0)"
        ctx.fillRect(0, 0, c.chart.width, c.chart.height)
    @drawGraph()
    self = @
    ###
    $('#download_link').on 'click', () ->
      self.downloadChartAsImage()
    ###
    #全てのローカルストレージを削除
    localStorage.clear()
    
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
            fontSize: 18
        chartArea:
          backgroundColor: '#000'
      
  downloadChartAsImage: ->
    canvas = document.getElementById 'myChart'
    downloadLink = document.getElementById('download_link')
    filename = 'your_order.jpg'
    if canvas.msToBlob
      blob = canvas.msToBlob()
      window.navigator.msSaveBlob blob, 'your_order.jpg'
    else
      downloadLink.href = canvas.toDataURL('image/jpg')
      downloadLink.download = filename
