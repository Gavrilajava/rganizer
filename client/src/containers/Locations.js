import React, {useState, useEffect} from 'react'
import Filter from './Filter'
import LocationForm from './LocationForm'

import {API_ROOT, HEADERS} from '../constants/api'

const Locations = () => {

  const [locations, setLocations] = useState([])
  const [filter, setFilter] = useState(null)
  const [update, setUpdate] = useState(false)
  
  useEffect(() => {
      fetch(API_ROOT + "/locations")
        .then(resp => resp.json())
        .then(json => setLocations(json))
  }, [update])

  const handleDelete = id => {
    fetch(API_ROOT + "/locations/"+ id, {
      method: "DELETE",
      headers: HEADERS
    })
      .then(() => setUpdate(!update))
  }

  const handleUpdate = (location, isActive) => {
    debugger
    fetch(API_ROOT + "/locations/" + location.id, {
      method: "PATCH",
      headers: HEADERS,
      body: JSON.stringify({
        location: {...location, isActive}
      })
    })
      .then(() => setUpdate(!update))
  }

  const renderRow = (location, index) => {
    return(
      <tr>
        <td>{index}</td>
        <td>
          <input type = "checkbox" onChange = {() => handleUpdate(location, !location.isActive)}checked = {location.isActive}/>
        </td>
        <td>{location.name}</td>
        <td>{location.locId}</td>
        <td>
          <button onClick = {() => handleDelete(location.id)}>Delete</button>
        </td>
      </tr>
    )
  }

  const filterLocations = () => {
    if (!filter){
      return locations
    }
    else{
      return locations.filter(location => location.name.toLowerCase().includes(filter.toLowerCase()))
    }
  }

  return(
    <>
    <Filter setFilter = {setFilter}/>
    <LocationForm update = {update} setUpdate = {setUpdate}/>
    <table>
      <tr>
        <th>#</th>
        <th>Active</th>
        <th>Name</th>
        <th>ID</th>
        <th>Delete</th>
      </tr>
      {filterLocations().map((loc, index) => renderRow(loc, index + 1))}
    </table>
    </>
  )
}

export default Locations