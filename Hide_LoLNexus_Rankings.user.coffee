`// ==UserScript==
// @name        Hide LoLNexus Rankings
// @namespace   FichteFoll
// @author      FichteFoll
// @description Want to know who you're playing against but don't care about ratings? Use this.
// @include     http://lolnexus.com/*
// @version     0.1.0
// @grant       none
// @require     https://userscripts.org/scripts/source/145813.user.js
// ==/UserScript==
`

### **TODO**
#
# -? Instead of animating opacity, animate width (DOESN'T WORK)
# -? Add a checkbox to each header to toggle it individually
###


# jshint stuff
### jshint newcap:false ###
### global jQuery:true ###
### global GM_setValue:true, GM_getValue:true, GM_deleteValue:true ###

# Luckily, LoLNexus uses jQuery so we can re-use it
$ = jQuery

# Shared (global) variables
$rank_cells = false
cells_hidden = false
auto_hide = GM_getValue("auto_hide", false) == 'true'

add_toggle_button = ->
  cells = $(".row-fluid").children()

  # adjust sizing of existing colums (before: [2, 2, 4, 2, 2] = 12)
  row_widths = [1, 2, 3, 2, 1] # new '3' will be inserted in the middle
  for i in [0...5]
    cells[i].className = "span#{row_widths[i]}"

  # I copied this from the spectate button and adjusted
  $("""<div class="span3 row-fluid" id="rank-toggle-div" style="text-align: center">
      <div id="toggle" class="span7 row-fluid" style="text-align:center; color:#f4f4f4">
        <a id="rank-toggle" class="btn btn-large btn-customBlue" href="#">
          Toggle rankings</a>
      </div>
      <input id="save-toggle" type="checkbox" style="height: 34px;" #{auto_hide and "checked" or ''}>
        Auto Hide
      </input>
    </div>""").insertAfter(cells[2])

  $("#rank-toggle").click ->
    toggle_rankings()

  $("#save-toggle").change ->
    GM_setValue("auto_hide", @checked)


toggle_rankings = (duration = 500) ->
  $rank_cells.animate "opacity": Number(cells_hidden), duration
  cells_hidden = !cells_hidden


### MAIN ###
$(document).ready ->
  $rank_cells = $("table[id^=set] td > img[src^='images/medals']").parent()
  return if !$rank_cells.length

  toggle_rankings 0 if auto_hide

  # add button for toggling
  add_toggle_button()
