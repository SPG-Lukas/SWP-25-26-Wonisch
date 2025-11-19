import * as p from "./repository/passenger.ts";

async function main(){
    try{
        const c = await p.count();
        console.log('passenger count =', c);
    }catch(e){
        console.error('error:', e);
    }
}

main();
