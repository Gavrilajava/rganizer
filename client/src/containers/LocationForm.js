import React, {useState} from 'react'

import {API_ROOT, HEADERS} from '../constants/api'

const LocationForm = ({update, setUpdate}) => {

  const [name, changeName] = useState("")
  const [locId, changeLocId] = useState("")

  const handleSubmit = e => {
    e.preventDefault()
    fetch(API_ROOT + '/locations', {
      method: "POST",
      headers: HEADERS,
      body: JSON.stringify({
        location: {
          name: name,
          locId: locId,
          isActive: true
        }
      })
    })
      .then(() => {
        setUpdate(!update)
        changeName("")
        changeLocId("")
      })
  }

  return(
    <form onSubmit = {handleSubmit}>
      <label>Name:</label>
      <input type = "text" value = {name} onChange={e => changeName(e.target.value)}></input>
      <label>ID:</label>
      <input type = "text" value = {locId} onChange={e => changeLocId(e.target.value)}></input>
      <input type = "submit" value = "Submit"></input>
    </form>
  )
}

export default LocationForm