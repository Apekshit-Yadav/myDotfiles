let num;
const min=1; 
const max=6;
const roll = document.getElementById("generator");
roll.onclick=function(){
    num=Math.floor(Math.random()*(max-min))+min;
    document.getElementById("mynum").textContent=num;    
}