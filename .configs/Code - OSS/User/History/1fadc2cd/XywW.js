let num;
document.getElementById("generator").onclick=function(){
    num=Math.floor(Math.random()*100)+1;
    document.getElementById("mynum").textContent=num;    
}