import React from 'react'
import {API_ROOT, HEADERS} from '../constants/api'

const Delete = () => {

  const handleDelete = () => {
    fetch(API_ROOT + "/postings", {
      method: "DELETE",
      headers: HEADERS
    })
      .then(() => console.log("deleted"))
  }

  return(
    <button onClick = {handleDelete}>Delete</button>
  )
}

export default Delete