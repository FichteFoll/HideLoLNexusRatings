// Generated by CoffeeScript 1.7.1
// ==UserScript==
// @name        Hide LoLNexus Rankings
// @namespace   FichteFoll
// @author      FichteFoll
// @description Want to know what runes your opponents use but don't want to see their ratings? Use this.
// @include     http://lolnexus.com/*/search*
// @include     http://www.lolnexus.com/*/search*
// @version     1.0.0
// @grant       none
// @downloadURL https://github.com/FichteFoll/HideLoLNexusRatings/raw/master/Hide_LoLNexus_Rankings.user.js
// ==/UserScript==
;
var $, $rank_cells, add_toggle_button, auto_hide, cells_hidden, toggle_rankings;

$ = jQuery;

$rank_cells = false;

cells_hidden = false;

auto_hide = localStorage.getItem("lolnexus_auto_hide", false) === 'true';

add_toggle_button = function() {
  $(".cv-upsell").after("<div style=\"position: relative; left: 50%; transform: translateX(-10%); margin-bottom: 8px;\">\n  <a id=\"rank-toggle\" class=\"blue-button\" href=\"#\" style=\"font-size: 12px;\">\n    Toggle rankings</a>\n  <br style=\"margin-bottom: 5px;\">\n  <input id=\"save-toggle\" type=\"checkbox\" style=\"margin-left: 20px;\" " + (auto_hide && "checked" || '') + ">\n  <span>\n    Auto Hide</span>\n</div>");
  $("#rank-toggle").click(function() {
    toggle_rankings();
    return false;
  });
  return $("#save-toggle").change(function() {
    return localStorage.setItem("lolnexus_auto_hide", this.checked);
  });
};

toggle_rankings = function(duration) {
  if (duration == null) {
    duration = 500;
  }
  $rank_cells.animate({
    "opacity": Number(cells_hidden)
  }, duration);
  return cells_hidden = !cells_hidden;
};


/* MAIN */

$(document).ready(function() {
  var check_for_cells;
  check_for_cells = function(tries) {
    if (tries == null) {
      tries = 1;
    }
    if (tries === 100) {
      return;
    }
    if ($(".error").length || $(".header-bar h2 small").html() === "Region Disabled") {
      return console.log("summoner not in game (or region disabled or unable to query server or ...)");
    }
    $rank_cells = $(".ranking");
    if (!$rank_cells.length) {
      setTimeout((function() {
        return check_for_cells(tries + 1);
      }), 100);
      return;
    }
    if (auto_hide) {
      toggle_rankings(0);
    }
    return add_toggle_button();
  };
  return check_for_cells();
});
