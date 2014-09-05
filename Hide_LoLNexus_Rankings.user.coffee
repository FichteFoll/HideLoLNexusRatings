`// ==UserScript==
// @name        Hide LoLNexus Rankings
// @namespace   FichteFoll
// @author      FichteFoll
// @description Want to know who you're playing against but don't care about ratings? Use this.
// @include     http://lolnexus.com/*/search*
// @include     http://www.lolnexus.com/*/search*
// @version     0.2.1
// @grant       none
// @require     https://userscripts.org/scripts/source/145813.user.js
// ==/UserScript==
`

# Luckily, LoLNexus uses jQuery so we can re-use it
$ = jQuery

# Shared (global) variables
$rank_cells = false
cells_hidden = false
auto_hide = GM_getValue("auto_hide", false) == 'true'

add_toggle_button = ->
  $(".cv-upsell").after """
    <div style="position: relative; left: 50%; transform: translateX(-10%); margin-bottom: 8px;">
      <a id="rank-toggle" class="blue-button" href="#" style="font-size: 12px;">
        Toggle rankings</a>
      <br style="margin-bottom: 5px;">
      <input id="save-toggle" type="checkbox" style="margin-left: 20px;" #{auto_hide and "checked" or ''}>
      <span>
        Auto Hide</span>
    </div>
    """

  $("#rank-toggle").click ->
    toggle_rankings()
    false

  $("#save-toggle").change ->
    GM_setValue("auto_hide", @checked)


toggle_rankings = (duration = 500) ->
  $rank_cells.animate("opacity": Number(cells_hidden), duration)
  cells_hidden = !cells_hidden


### MAIN ###
$(document).ready ->
  # Periodically try to find ranking boxes since they are now loaded "on the fly"
  # Try 100 times every 100ms, which makes 10s, and abort if error message shown
  check_for_cells = (tries = 1) ->
    return if tries == 100

    # Check if summoner is not in game or region disabled
    if $(".error").length or $(".header-bar h2 small").html() == "Region Disabled"
      return console.log "summoner not in game (or region disabled or unable to query server or ...)"

    $rank_cells = $(".ranking")
    if !$rank_cells.length
      # Retry
      setTimeout (-> check_for_cells(tries + 1)), 100
      return

    # console.log "tries:", tries
    # console.log $rank_cells

    toggle_rankings 0 if auto_hide

    # add button for toggling, and also checkbox for auto toggle
    add_toggle_button()

  check_for_cells()
