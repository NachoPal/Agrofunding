// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs

$(document).ready(function(){

	$('#agro').on('click',function(){
		$('#sign-in-agrofunder').fadeIn();
		$('#sign-in-farmer').hide();
		$('#landing').css('background','url("/agrofunder3.jpg") center');
	});

	$('#farmer').on('click',function(){
		$('#sign-in-agrofunder').hide();
		$('#sign-in-farmer').fadeIn();
		$('#landing').css('background','url("/farm3.jpg") center');
	});
});