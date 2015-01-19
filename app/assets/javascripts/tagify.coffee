#= require jquery-ui/autocomplete
#= require bootstrap-tokenfield

$ ->
  customizeAutocomplete = ->
    oldFn = $.ui.autocomplete::_renderItem
    $.ui.autocomplete::_renderItem = (ul, item) ->
      term = @term.toLowerCase()
      new_label = item.label.toLowerCase().replace(term, "<span style='font-weight:bold;color:black;'>" + term + "</span>")
      $("<li></li>").data("item.autocomplete", item).append("<a>" + new_label + "</a>").appendTo ul

  getCurrentValues = (target) ->
    inputField = getInputField(target)
    currentValues = if !!inputField.val() then JSON.parse(inputField.val()) else []

  getInputField = (target) ->
    getWrapperField(target).next()

  getWrapperField = (target) ->
    target.closest('.tokenfield')

  enterNewValue = (selectedValue, target) ->
    inputField = getInputField(target)
    currentValues = getCurrentValues(target)

    if !!target.data('max') && currentValues.length >= target.data('max')
      shiftedValue = currentValues.shift()
      wrapper = getWrapperField(target)
      wrapper.find('.token').first().remove()

    currentValues.push(selectedValue)
    inputField.val(JSON.stringify(currentValues))

  removeExistingValue = (selectedValue, target) ->
    inputField = getInputField(target)
    currentValues = getCurrentValues(target)
    currentValues = $.grep currentValues, (value) ->
      value.toString() != selectedValue.toString()
    inputField.val(JSON.stringify(currentValues))

  searchJSON = (data, regex, target) ->
    result = []
    currentValues = getCurrentValues(target)
    $.each data, (i, row) ->

      if row.label.match(regex) && currentValues.indexOf(row.value) == -1
        result.push row
      return
    result.slice(0,10)

  retrieveExistingTokens = (data, target) ->
    tokens = []
    currentValues = getCurrentValues(target)
    $.each data, (i, row) ->
      if currentValues.indexOf(row.value) != -1
        tokens.push row
      return
    tokens

  initTagify = ->
    $this = $(this)
    filename = $this.data('file')

    $.getJSON '/' + filename + '.json', (data) ->

      customizeAutocomplete()

      $this.tokenfield
        autocomplete:
          source: (request, response) ->
            result = searchJSON(data,request.term.toLowerCase(), $this)
            response result
          select: (e, ui) ->
            selectedValue = ui.item.value
            enterNewValue(selectedValue, $this)
        delimiter: ''
      .on 'tokenfield:removedtoken', (e) ->
        selectedValue = e.attrs.value
        removeExistingValue(selectedValue, $this)

      tokens = retrieveExistingTokens(data, $this)
      $this.tokenfield('setTokens', tokens);

  $('.tagify').each ->
    initTagify.apply this

  $(document).on 'mouseenter focus', '.tagify', ->
    initTagify.apply this
