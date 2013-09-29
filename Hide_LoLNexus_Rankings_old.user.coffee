`// ==UserScript==
// @name        Hide LoLNexus Rankings
// @namespace   FichteFoll
// @author      FichteFoll
// @description Want to know who you're playing against but don't care about ratings? Use this.
// @include     http://lolnexus.com/*
// @version     0.1
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

# Shared variables
$rank_cells = null
# $rank_headers = null
cells_hidden = false
save_toggle = GM_getValue("save_toggle", true) == 'true'


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
      <input id="save-toggle" type="checkbox" style="height: 34px;" #{save_toggle and "checked" or ''}>
        Save Toggle
      </input>
    </div>""").insertAfter(cells[2])

  $("#rank-toggle").click ->
    toggle_rankings()

  $("#save-toggle").change ->
    save_toggle = @checked
    GM_setValue("save_toggle", save_toggle)
    if save_toggle
      GM_setValue("cells_hidden", cells_hidden)
    else
      GM_deleteValue("cells_hidden")



toggle_rankings = (duration = 500) ->
  $rank_cells.animate "opacity": Number(cells_hidden), duration
  cells_hidden = !cells_hidden

  GM_setValue("cells_hidden", cells_hidden) if save_toggle


### MAIN ###
$(document).ready ->
  $rank_cells = $("table[id^=set] td > img[src^='images/medals']").parent()
  return if !$rank_cells.length

  # $rank_headers = $rank_cells.closest("table")
  #                 .find("th[title$=rating], th[oldtitle$=rating]")

  toggle_rankings 0 if GM_getValue("cells_hidden", false) == 'true'

  # add button for toggling
  add_toggle_button()

  # window.toggle_rankings = toggle_rankings # DEBUG
