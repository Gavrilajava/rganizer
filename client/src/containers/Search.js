import React from 'react'
import {API_ROOT, HEADERS} from '../constants/api'

const Search = () => {

  const handleClick = () => {
    fetch(API_ROOT + "/search", {
      method: "POST",
      headers: HEADERS,
      body: JSON.stringify({request: "Please, find me the job"})
    })
      .then(() => console.log("search started"))
  }

  return(
    <button onClick = {handleClick}>Search</button>
  )
}

export default Search