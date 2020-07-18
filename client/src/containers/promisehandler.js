

const promiceCombiner = (promises) => {

  return Promise.allSettled(promises)
    .then(results => results.reduce((sum, val) => val.status === "fulfilled" ? {status: "fulfilled", value: sum.value + val.value} : sum, {status: 'rejected', value: 0 }))
    .then(total => total.status === "rejected" ? Promise.reject(0) : Promise.resolve(total.value))
    .catch(err => 0)
}

let promisesArray = [Promise.resolve(33), Promise.reject(44)];

promiceCombiner(promisesArray).then(res => console.log(res))