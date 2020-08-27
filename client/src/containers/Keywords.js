import React, {useState, useEffect} from 'react'
import Filter from './Filter'
import KeywordsForm from './KeywordsForm'

import {API_ROOT, HEADERS} from '../constants/api'

const Keywords = () => {

  const [keywords, setKeywords] = useState([])
  const [filter, setFilter] = useState(null)
  const [update, setUpdate] = useState(false)
  
  useEffect(() => {
      fetch(API_ROOT + "/keywords")
        .then(resp => resp.json())
        .then(json => setKeywords(json))
  }, [update])

  const handleDelete = id => {
    fetch(API_ROOT + "/keywords/"+ id, {
      method: "DELETE",
      headers: HEADERS
    })
      .then(() => setUpdate(!update))
  }

  const handleUpdate = (keyword) => {
    debugger
    fetch(API_ROOT + "/keywords/" + keyword.id, {
      method: "PATCH",
      headers: HEADERS,
      body: JSON.stringify(keyword)
    })
      .then(() => setUpdate(!update))
  }

  const renderRow = (keyword, index) => {
    return(
      <tr>
        <td>{index}</td>
        <td>
          <input type = "checkbox" onChange = {() => handleUpdate({...keyword, isActive: !keyword.isActive})} checked = {keyword.isActive}/>
        </td>
        <td>{keyword.title}</td>
        <td>
          <input type = "checkbox" onChange = {() => handleUpdate({...keyword, isEntryLevel: !keyword.isEntryLevel})} checked = {keyword.isEntryLevel}/>
        </td>
        <td>
          <button onClick = {() => handleDelete(keyword.id)}>Delete</button>
        </td>
      </tr>
    )
  }

  const filterKeywords = () => {
    const sortedKeywords = keywords.sort((a,b) => a.id - b.id)
    if (!filter){
      return sortedKeywords
    }
    else{
      return sortedKeywords.filter(keyword => keyword.name.toLowerCase().includes(filter.toLowerCase()))
    }
  }

  return(
    <>
    <Filter setFilter = {setFilter}/>
    <KeywordsForm update = {update} setUpdate = {setUpdate}/>
    <table>
      <tr>
        <th>#</th>
        <th>Active</th>
        <th>Title</th>
        <th>Entry Level</th>
        <th>Delete</th>
      </tr>
      {filterKeywords().map((loc, index) => renderRow(loc, index + 1))}
    </table>
    </>
  )
}

export default Keywords