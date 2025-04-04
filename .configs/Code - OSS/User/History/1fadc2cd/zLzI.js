let num;
document.getElementById("generator").onclick=function(){
    num=Math.random()*100;
    num=Math.trunc();
    document.getElementById("mynum").textContent=num;    
}