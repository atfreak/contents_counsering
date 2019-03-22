$ ->
  app.initialize()

window.app =
  initialize: ->
    @setNotSideView()
    @setListSize()
    self = @
    $(window).on 'resize', ->
      self.setListSize()
      #端末を縦で見るとき
      self.setNotSideView()
    @is_submit = true
    @page_count = 1
    @json_data = []
    @evaluate_point = [0,0,0,0]
    @item = ['cute', 'beautiful', 'durability', 'reproduction']
    @getJsonData()
    @setTitle()
    @setBind()

  setNotSideView: ->
    w_height = $(window).height()
    if w_height <= 800
      $('.form-head').css 'top', '7%' 
      $('.form-wrap ul').css 'padding-top', '18%'
      $('.paginate-wrap').css 'bottom', '9%' 
    else
      $('.form-head').css 'top', '25%' 
      $('.form-wrap ul').css 'padding-top', '45%' 
      $('.paginate-wrap').css 'bottom', '27%' 

  setListSize: ->
    set_w_height = $(window).height()
    $('.contents-wrap').css 'height', set_w_height
    set_list_width = $('#list01 .data-list').width()
    set_list_height01 = Math.floor(Math.floor($('#list01 .data-list').width()))
    set_list_height02 = Math.floor(Math.floor($('#list02 .data-list').width()))
    set_list_height03 = Math.floor(Math.floor($('#list03 .data-list').width()) * 1.13)
    $('#list01 .data-list').css 'height', set_list_height01
    $('#list02 .data-list').css 'height', set_list_height02
    $('#list03 .data-list').css 'height', set_list_height03

  setTitle: ->
    page_title = ['髪質改善', '頭皮ケア', 'デザイン']
    $('.form-head h1').text page_title[@page_count - 1]

  getJsonData: ->
    self = @
    $.getJSON "./assets/js/data.json", (data) ->
      self.json_data = data

  setBind: () ->
    $('.data-list').on 'click', ->
      $(@).toggleClass 'active'
    @setPageMove()

  setPageMove: ->
    self = @
    $('.paginate-wrap .page-move').on 'click', ->
      val = $(@).attr 'data-page'
      self.page_count = Number val
      if self.page_count isnt 4
        self.doPageMove(val)
      self.setTitle()
      self.setListSize()
      if self.page_count is 4 and $(@).hasClass 'right-box'
        self.setValidate()
        if self.is_submit
          self.setGraphData()
          self.saveGraphData()
          self.saveYourName()
          location.href = './result.html'

  doPageMove: (val) ->
    is_page = 'page0' + Number val
    @setPagination()
    $('body').removeClass().addClass is_page

  setPagination: ->
    before_page_count = @page_count - 1
    next_page_count = @page_count + 1
    $('.paginate-wrap .left-box').attr 'data-page', before_page_count
    $('.paginate-wrap .right-box').attr 'data-page', next_page_count

  setGraphData: ->
    count = 0
    self = @
    $('.item-list li.active').each ->
      i = 0
      set_num = $(@).attr 'data-id'
      filtered_id = $.grep self.json_data, (elem, index) ->
        return elem.id == Number set_num
      self.evaluate_point.forEach (val) ->
        add_val = Number val + Number filtered_id[0].point[i]
        self.evaluate_point[i] = add_val
        i++

  setValidate: ->
    @is_submit = true
    set_num = 0
    set_name = $('input[name="name"]').val()
    error_msg = ''
    $('.item-list li.active').each ->
      set_num += $(@).attr 'data-id'
    if set_num is 0
      @is_submit = false
      error_msg += '一つ以上項目をご選択ください\n'
    if !set_name 
      @is_submit = false
      error_msg += 'お名前をご入力ください'
    if !@is_submit
      alert error_msg
      
  saveYourName: ->
    set_your_name = $('input[name="name"]').val()
    localStorage.setItem 'yourname', set_your_name

  saveGraphData: ->
    i = 0
    for val in @evaluate_point
      localStorage.setItem @item[i], val
      i++
