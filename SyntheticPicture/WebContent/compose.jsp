<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<script type="text/javascript" src="./js/jquery1.42.min.js"></script>
	<script type="text/javascript" src="./js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="./js/hammer.min.js"></script>
	<script type="text/javascript" src="./js/exif.js" ></script>  
	<title>一书阁</title>
	<style type="text/css">
		body,html{
			height: 100%;
			padding: 0px;
			margin: 0px;
		}
		#component{

		}
		#component .canvas-content{
			height: 100%;
			background-color:#EFC67E;
			position: relative;
		}
		#component .control-btn{
			height: 10%;
			background-color: #fff;
			display: flex;
		    justify-content: center;
		    align-items: center;
		}
		#component .control-btn2{
			position:absolute;
			top:62%;width:5rem;
			left:50%;
			transform: translate(-50%,-50%);
			z-index: 2000;
		}
		.control-btn2 .integration-btn{
			padding:.3rem .1rem;
			text-align: center;
		    background-color: #ef8200;
		    color:#fff;

		}
		#component .canvas-bg img{

			max-height: 98%;
			max-width: 90%;
		}
		#component .canvas-bg{
			position: relative;
			display: flex;
		    justify-content: center;
		    align-items: center;
		    margin: auto;
		    height: 100%;
		}
		#component .canvas-bg-middle{

		}

		.control-btn .integration-btn{
			padding:5px;
			width: 20%;
			text-align: center;
		    background-color: #4AA9E6;
		    color:#fff;

		}
		#component .upload{
			height: 150px;
			width: 62%;
			position: absolute;
			top: 40%;	
			left: 50%;
			transform:translate(-50%,-50%); 
			background-color: blue;
			display: table;
		}
		#component .upload input{
			opacity:0;
			display: inline-block;
		    position: absolute;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%,-50%);
		    height: 100%;
		    width: 100%;
		}
		.upload-btn{
		    text-align: center;
		    display: table-cell;
		    vertical-align: middle;
		    position: absolute;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%,-50%);
		    width: 90%;
		    z-index: 2;
		}
		.upload-hint{
			margin-top: 5px;
			margin-bottom: 5px;
		    color: #aa8c5b;
    		font-size: 16px;
		}
		.canvas-content-bg{
			position: relative;
			z-index: 10;
		}
		.canvas-content-middle{
			display: inline-block;
			position: absolute;
			overflow: hidden;
		    /* top: 50%;
		    left: 50%;
			transform: translate(-50%,-50%); */
		}
		#file{
			height: 100%;
		    width: 100%;
		    position: absolute;
		    top: 0px;
		    left: 0px;
		    opacity: 0;
		}
		.user-upload-img{
		    position: absolute;
		    top: 0px;
		    left: 0px;
		    width: 100%;
		    height: 100%;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		}
		.user-upload-img img{
			max-height: 200%;
			max-width: 200%;
			position: relative;
			z-index: 5;
		}
		.canvas-window{
			position: absolute;
		    top: 21.5%;
    		left: 50%;
   			width: 66%;
    		height: 37%;
		    background: #fff;
		    z-index: 30;
		    transform: translate(-50%,0);
		    overflow: hidden;
		}
		
		.cover-tip{
			position: fixed;
			top:0;
			bottom:0;
			left:0;
			right:0;
			background:rgba(0,0,0,0.6);
			z-index:100;
		}
		.cover-tip-text{
			position: absolute;
			top:20%;
			z-index:110;
			color:#fff;
			font-size:1rem;
			width:18rem;
			left:50%;
			margin-left:-9rem;
		}
		
		.cover-tip-text:after{
			content:'.';
			display:block;
			width:48px;
			height:48px;
			background:url('img/tip.png') no-repeat;
			position: absolute;
			top:-50px;
			right:0;
		}
	</style>
</head>
<body>
<div id="component">
		<div class="canvas-content">
			<div class="canvas-content-middle">
				<img src="./img/backt.png" class="canvas-content-bg" id="backView">
				<div class="canvas-window">
					<div class="upload-btn">
						<img src="./img/camera.png">
						<div class="upload-hint" style="color:#aa8c5b">点击上传图片</div>
						<div style="font-size:15px">建议上传2M以下的照片</div>
						<input type="file" id="file" accept="image/*">
					</div>
					<div class="user-upload-img">
						<img id="view">
					</div>	
				</div>
				<div class="control-btn2" style="display: none;">
				<div class="integration-btn" onclick="compose()">
					点击合成
				</div>	
				</div>
			</div>
		</div>
		
	</div>
</body>
<script type="text/javascript">
	var clientHeight = document.querySelector(".canvas-content").clientHeight;
	var clientWidth = document.querySelector(".canvas-content").clientWidth;
	var height = document.documentElement.clientHeight;
	var width = document.documentElement.clientWidth;
	var scale = 1;
	var orient = 1;
	var tarSrc = '';
	var deg = 0;
	/* $(".canvas-content-bg").css("max-height",clientHeight*1); */
	$(".canvas-content-bg").css("width",clientWidth*1);

	document.querySelector('#file').addEventListener('change', function(){

			

			$(".upload-btn").css("display","none");
	        if(this.files.length === 0){
	            document.querySelector('#view').src = '';
		    $(".upload-btn").css("display","block");
	            return;
	        }
		$("#view").unbind("touchstart",thismousedown );			
		$("#view").unbind("touchend", thismouseup);			
		$("#view").unbind("touchmove",thismousemove );			

		$("#view").remove();


		var newImg = document.createElement('img');
		newImg.id = "view";
		newImg.onclick = imgClick;

		newImg.addEventListener('touchstart',thismousedown);  
	    newImg.addEventListener('touchend',thismouseup); 
	    newImg.addEventListener('touchmove',thismousemove); 

	    oDiv2 = newImg;

	    var hammertime = new Hammer(newImg);
		hammertime.get('pinch').set({ enable: true });
		hammertime.get('rotate').set({ enable: true });
		hammertime.on('pinch', function(e) {
			oDiv2.style.transform = "scale("+e.scale+")";
			scale = e.scale;
			
		});
		
		$(".user-upload-img").append(newImg);
	        var reader = new FileReader();
	        reader.readAsDataURL(this.files[0]);
	        reader.onload = function (e) {
	            var timg = document.querySelector('#view');
	            timg.onload = function(){
                	orient = getPhotoOrientation(this);
                	if(orient){
             			switch(orient) {
						    case 1:  
						    	// 0
						        break;
						    case 6:
						    	//transform: rotate(270deg);
						    	deg = 90;
						    	//timg.style.transform = "rotate("+90+"deg)";
						    	//ctx.rotate(270*Math.PI/180);
						        break;
						    case 8:
						    	deg = 270;
						    	//timg.style.transform = "rotate("+270+"deg)";
								//ctx.rotate(90*Math.PI/180);
						        break;
						    case 3:
						    	deg = 180;
						    	//ctx.rotate(180*Math.PI/180)
						    	//timg.style.transform = "rotate("+180+"deg)";
						        break;

						};



						var src =tarSrc;
						var scale = 1;

								var img_z = timg;
		var can_z = document.createElement("canvas");
		var context_z = can_z.getContext("2d");
		var t;	
		

			var width = img_z.width;
			var height = img_z.height;
			can_z.width = width*scale;
			can_z.height = height*scale;
			switch(deg){
				case  90:
					t = can_z.width;
					can_z.width = can_z.height;
					can_z.height = t;
					context_z.rotate(deg*Math.PI/180);
					context_z.translate(0, -height*scale);
					context_z.scale(scale,scale);
					//context_z.drawImage(img_z,0,0,width,height);
					break;
				case  180:
					context_z.rotate(deg*Math.PI/180);
					context_z.translate(-width*scale,-height*scale);
					context_z.scale(scale,scale);
					//context_z.drawImage(img_z,0,0,width,height);
					break;
				case  270:
					t = can_z.width;
					can_z.width = can_z.height;
					can_z.height = t;
					context_z.rotate(deg*Math.PI/180);
					context_z.translate(-width*scale,0);
					context_z.scale(scale,scale);
					//context_z.drawImage(img_z,0,0,width,height);
					break;
			}

			context_z.drawImage(img_z,0,0,width,height);
					
					var dataURL = can_z.toDataURL("image/png");
					timg.onload = null;
					timg.src = dataURL;

                	}

		            $(".control-btn2").fadeIn();
	            };
	            timg.src = tarSrc = e.target.result;

	      	};
	});	

	function imgClick(){
		$("#file").click();
	}

	$("#view").bind("click",imgClick);

	
	function getPhotoOrientation(img){
	    var orient = 1;
	    EXIF.getData(img, function () {
	        orient = EXIF.getAllTags(img).Orientation;
	    });
	    return orient;
	}

 	var isdrag=false;   
    var NowLeft,disX;
    var NowTop,disY; 

	var oDiv2 = $("#view")[0];
	oDiv2.addEventListener('touchstart',thismousedown);  
    oDiv2.addEventListener('touchend',thismouseup);  
    oDiv2.addEventListener('touchmove',thismousemove);  

    function thismousedown(e){   
       isdrag = true;   
       NowLeft = parseInt(oDiv2.style.left+0);  
       NowTop = parseInt(oDiv2.style.top+0);   
       disX = e.touches[0].pageX;   
       disY = e.touches[0].pageY;
       return false;
    }

    function thismousemove(e){   
      if (isdrag){

       oDiv2.style.left = NowLeft + e.touches[0].pageX - disX + 'px'; 
       oDiv2.style.top = NowTop + e.touches[0].pageY - disY + 'px';

       return false;   
       }   
    }   

    function thismouseup(){  
        isdrag = false;  
    };
	
	var hammertime = new Hammer($("#view")[0]);
	hammertime.get('pinch').set({ enable: true });
	hammertime.get('rotate').set({ enable: true });
	hammertime.on('pinch', function(e) {
		oDiv2.style.transform = "scale("+e.scale+")";
		scale = e.scale;
		
	});
	
	
	function compose(){
		var rect = document.getElementById("view").getBoundingClientRect();
		var scrollTop = document.querySelector("#component").scrollTop;
		var backimg=document.getElementById("backView");
		var backRect = backimg.getBoundingClientRect();
		clientWidth = backimg.width;
		clientHeight = backimg.height;
		var canvas = document.createElement('canvas'); 
		canvas.id="CursorLayer"; 
		canvas.width=clientWidth;
		canvas.height=clientHeight;
		canvas.style.zIndex=8; 
		canvas.style.position="absolute"; 
		var ctx=canvas.getContext("2d");
		
        
        var  devicePixelRatio = window.devicePixelRatio || 1,   
		backingStoreRatio = ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1, 
		ratio = devicePixelRatio / backingStoreRatio;
		var oldWidth = canvas.width; 
		var oldHeight = canvas.height; 
		canvas.width = oldWidth * ratio; 
		canvas.height = oldHeight * ratio; 
		canvas.style.width = oldWidth + 'px'; 
		canvas.style.height = oldHeight + 'px'; 
		ctx.scale(ratio, ratio);
		
		
        ctx.fillStyle = "#fff";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
			var img=document.getElementById("view");
			var bx = backRect.left;
			var x = rect.left-bx;
			var to = $(document).scrollTop();
			var y = rect.top + to;
			var w = img.width*scale;
			var h = img.height*scale;

			ctx.drawImage(img,x,y,w,h);


			var backImgSrc = "img/backt.png";
			var backImg = new Image();
			backImg.onload = function(){
				var bw = clientWidth;
				var bh = clientHeight;
				ctx.drawImage(backImg,0,0,bw,bh);			
				document.body.innerHTML="";
				var dataURL = canvas.toDataURL("image/png");
				var str = "<img src='"+dataURL+"' width="+width+"/>";
				var tipMessage =  '<div class="cover-tip" onclick="_hide()"></div><div class="cover-tip-text">您可以长按图片保存到手机里，然后分享到朋友圈发送给您的朋友啦！</div> ';
				document.body.innerHTML=str+tipMessage;
			}
			backImg.src = backImgSrc;

	}
	
	function _hide(){
		$(".cover-tip").hide();
		$(".cover-tip-text").hide();
	}
</script>
</html>