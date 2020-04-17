window.onload = function(){
	console.log('로그인 체크');
	var isLogOn=document.getElementById("logon").value;
	
	if(isLogOn=="false" || isLogOn=='' ){
		document.body.style.display = "none";
		setTimeout(function(){
			var target = document.getElementById('pageLayer');
			console.log(target);
			target.remove();
			document.body.style.overflow = 'auto';
		}, 3000);
		alert('로그인이 필요한 페이지입니다.');
		window.location.href="/mall/main.do";
		return;
	}
}
function clearCover(){
	
}