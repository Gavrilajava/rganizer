import React, {useState} from 'react'

import {API_ROOT, HEADERS} from '../constants/api'

const KeywordsForm = ({update, setUpdate}) => {

  const [title, changeTitle] = useState("")
  const [isEntryLevel, changeIsEntryLevel] = useState(false)

  const handleSubmit = e => {
    e.preventDefault()
    fetch(API_ROOT + '/keywords', {
      method: "POST",
      headers: HEADERS,
      body: JSON.stringify({
        keyword: {
          title: title,
          isEntryLevel: isEntryLevel,
          isActive: true
        }
      })
    })
      .then(() => {
        setUpdate(!update)
        changeTitle("")
      })
  }

  return(
    <form onSubmit = {handleSubmit}>
      <label>Keywords:</label>
      <input type = "text" value = {title} onChange={e => changeTitle(e.target.value)}></input>
      <label>EntryLevel:</label>
      <input type = "checkbox" onChange = {() => changeIsEntryLevel(!isEntryLevel)}checked = {isEntryLevel}/>
      <input type = "submit" value = "Submit"></input>
    </form>
  )
}

export default KeywordsForm