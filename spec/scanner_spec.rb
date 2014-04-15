require_relative 'spec_helper'
require 'active_support/core_ext/string/strip'

describe Scanner, fakefs: true do
 
  subject(:scanner) { Scanner.new(input_file, output_file) }

  let(:output_filename) { 'output.yml' }
  let(:output_file) { File.open(output_filename, 'w') }  

  after do
    output_file.close if !(!output_file || output_file.closed?)
  end

  describe '#scan_sass' do

    before do
      File.write(input_filename, input_content)
    end

    after do
      input_file.close if !(!input_file || input_file.closed?)
      File.delete(input_filename)
    end

    let(:input_file) { File.open(input_filename, 'r') }
    let(:input_filename) { 'test_file.sass' }

    let(:input_content) do
      <<-END_SASS.strip_heredoc
        #id_selector
            border: 1px solid #ccc
            padding: 10px
            color: #333
        
        .class_selector
            float: left
            width: 600px
        
        #id_selector
            background-color: #375
          
        @media screen and (max-width: 979px) 
            #main
                padding-top: 0px
                
        form.no-margin
            margin: 0

        #header
            padding: 0 1% 0 1%
            &.raised
                z-index: 8900

        #concrete-fields-pane .slimScrollDiv
            margin-top: -10px

        #concrete-fields-pane .slimScrollBar
            opacity: 0.1 !important
            &:hover
                opacity: 0.2  !important

        #concrete-fields-pane .slimScrollDiv>#accordions
            margin-top: 0px

        .delete-select-dropzone.active
            border: 2px dashed #EFEFEF

        #searchbox > i.fa
            display: none

        .btn-dedupe:hover, #btn-dedupe:focus
            color: white
            
        .btn-dedupe[disabled]
            color: white
        
        #dedupe-drop > div.dedupe:not(.ui-sortable-helper):first-child
            &:before
                content: "Criteria:"
                
        .select-header .row-fluid [class*="span"]
            min-height: 20px !important

        input:checked + .select-option-text
            color: black
            
        div#range-text span, span#total-cap-current
            font-weight: bold

        .dropdown-menu > li > a.hover-breakdown-color
            &:hover
                background-color: #49afcd
                background-image: -moz-linear-gradient(top, #5bc0de, #2f96b4)

        // comment 1
        
        #id_hover // comment 2
        
        /* Related to the positioning */
              
        #id_hover /* hola */
            border-radius: 0px
            
        /***** 
        * CONCRETE FIELDS PANE 
        *****/
        
        @import bootstrap2-switchhtml, body 
            height: 100%
        
        #id_hover       
      END_SASS
    end

    it 'writes the result as a YAML to the output file' do
      expected_result = {
        '#id_selector'                                                   => [1, 10],
        '.class_selector'                                                => [6],
        '#main'                                                          => [14],
        'form.no-margin'                                                 => [17],
        '#header'                                                        => [20],
        '&.raised'                                                       => [22],
        '#concrete-fields-pane .slimScrollDiv'                           => [25],
        '#concrete-fields-pane .slimScrollBar'                           => [28],
        '&:hover'                                                        => [30,62],
        '#concrete-fields-pane .slimScrollDiv>#accordions'               => [33],
        '.delete-select-dropzone.active'                                 => [36],
        '#searchbox > i.fa'                                              => [39],
        '.btn-dedupe:hover'                                              => [42],
        '#btn-dedupe:focus'                                              => [42],
        '.btn-dedupe[disabled]'                                          => [45],
        '#dedupe-drop > div.dedupe:not(.ui-sortable-helper):first-child' => [48],
        '&:before'                                                       => [49],
        '.select-header .row-fluid [class*="span"]'                      => [52],
        'input:checked + .select-option-text'                            => [55],
        'div#range-text span'                                            => [58],
        'span#total-cap-current'                                         => [58],
        '.dropdown-menu > li > a.hover-breakdown-color'                  => [61],
        '#id_hover'                                                      => [68, 72, 82]  
      }
      scanner.scan_sass
      expect(YAML.load_file(output_filename)).to eq expected_result
    end    
  end #scan-sass

  describe '#scan_coffee' do

    before do
      File.write(input_filename, input_content)
    end
    
    after do
      input_file.close if !(!input_file || input_file.closed?)
      File.delete(input_filename)
    end

    let(:input_file) { File.open(input_filename, 'r') }
    let(:input_filename) { 'test_file.js.coffee' }
    
    let(:input_content) do
      <<-END_SASS.strip_heredoc
        # Example:
        _l = _L["orders"]
        Paloma.callbacks["orders"]["show"] = (params) ->

          _l.asyncLoad()
          
          $('#main').on 'click', 'i.fa-refresh', (e) ->
            $('#order-result').find('.async-div').updateData('refresh', true)
          
          $("#main").on 'click', 'i.fa-refresh', (e) ->
            $("#order-result").find('.async-div').updateData('refresh', true)          
              
          window.setTimeout (->
            $("#alert-message").fadeTo(500, 0).slideUp 500, ->
              $(@).remove()
          ), 3000
          
          locals.handleScroll = ->
            threshold = $('#navbar').height()      
            
          $("#navbar, #header-wrapper, #concrete-fields-pane").each ->
            $(this).changeTop(adjustedLast - adjustedNew)      
          
          else if (newScroll < threshold) && (locals.lastScroll >= threshold)
            $('#header').removeClass('raised')      
            
          locals.asyncLoad = ->
            $(".async-div[data-refresh='true']").each ->
              asyncDiv = $(@)
              
          fieldPresence = $('.breakdown[data-cf-id='+breakdownId+']').length

          button = $('#enter_values_select_'+selectId+' > button')

          $("[data-toggle=\"popover\"]").each ->    

          $("#select_"+groupId+" .select-content").slideToggle "fast", ->

          fieldPresence = $('.dedupe[data-cf-id='+dedupeId+']').length

          fieldPresence = $('.output[data-cf-id='+outputId+']').length

          fieldPresence = $('.select[data-cf-id='+selectId+']').length
          
          locals.setBindings = () ->
            $(".flash-alert").on "click", "a.close", (e) ->
              $(@).closest(".flash-alert").remove()
              
          currentFieldsCount = $('#breakdown-drop').children('.breakdown').length
          
          locals.actionHeader = (anchor) ->
            chevronIcon = anchor.children("span").children('i')
            
          $(@).children(':not(:hidden)')
          
          $(@).children(":not(:hidden)")          
      END_SASS
    end
  
    it 'writes the result as a YAML to the output file' do
      expected_result = {
        '#main'                                      => [7,10],
        '#order-result'                              => [8,11],
        '.async-div'                                 => [8,11],
        '#alert-message'                             => [14],
        '#navbar'                                    => [19,21],
        '#header-wrapper'                            => [21],
        '#concrete-fields-pane'                      => [21],
        '#header'                                    => [25],
        ".async-div[data-refresh='true']"            => [28],
        ".breakdown[data-cf-id='+breakdownId+']"     => [31],
        "#enter_values_select_'+selectId+' > button" => [33],
        "[data-toggle=\"popover\"]"                  => [35],
        '#select_"+groupId+" .select-content'        => [37],
        ".dedupe[data-cf-id='+dedupeId+']"           => [39],
        ".output[data-cf-id='+outputId+']"           => [41],
        ".select[data-cf-id='+selectId+']"           => [43],
        '.flash-alert'                               => [46,47],
        '#breakdown-drop'                            => [49],
        '.breakdown'                                 => [49],
        'span'                                       => [52],
        'i'                                          => [52],
        ':not(:hidden)'                              => [54, 56]
      }
      scanner.scan_coffee
      expect(YAML.load_file(output_filename)).to eq expected_result
    end  
  end #scan-coffee

end
