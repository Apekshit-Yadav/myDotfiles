const myAge=document.getElementById("myage");
const mySubmit=document.getElementById("submit");
const res=ducument.getElementById("result");
let age = myAge.value;
muSubmit.onclick=function(){
    if(age>=100)
        res.textContent="You are TOO OLD to enter this site";
    else if(age==0)
        res.textContent="You are just born!";
    else if(age>=18)
        res.textContent="You can enter this site";
    else res.textContent="You must be 18+ enter this site";
    
}