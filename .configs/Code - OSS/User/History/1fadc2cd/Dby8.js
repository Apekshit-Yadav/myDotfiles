let num;
const min=1; 
const max=6;
const roll = document.getElementById("generator");
const haedin = document.getElementById("mynum");
roll.onclick=function(){
    num=Math.floor(Math.random()*max)+min;
    haedin.textContent=num;    
}