let testScore = 93;
let gradeCheck;

switch(false){
    case testScore>90:
        gradeCheck="A";
        break;
    case false:
        gradeCheck="failure";
    default:
        console.log("pfft");
}

console.log(gradeCheck);