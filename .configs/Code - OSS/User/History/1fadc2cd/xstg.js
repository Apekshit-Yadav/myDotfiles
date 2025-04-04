let num;
document.getElementById("generator").onclick=function(){
    num=Math.random()*100;
    document.getElementById("mynum").textContent=num;    
}