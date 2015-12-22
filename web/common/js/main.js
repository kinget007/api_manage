$(function(){
	$('#target-editor-twitter').markdown({
		hiddenButtons:'cmdPreview',
		//footer:'<div id="twitter-footer" class="well" style="display:none;"></div><small id="twitter-counter" class="text-success">140 character left</small>',
		onChange:function(e){
			var content = e.parseContent(),
				content_length = (content.match(/\n/g)||[]).length + content.length

			if (content == '') {
				$('#twitter-footer').hide()
			} else {
				$('#twitter-footer').show().html(content)
			}		
			$('#twitter-counter').removeClass('text-success').addClass('text-danger').html(content_length)
		}
	})
})