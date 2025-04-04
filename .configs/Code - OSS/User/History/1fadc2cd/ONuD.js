let num;
document.getElementById("generator").onclick=function(){
    num=Math.random()*100;
    console.log(num);
    num=Math.trunc();
    document.getElementById("mynum").textContent=num;    
}