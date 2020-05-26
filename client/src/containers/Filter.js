import React from 'react'


const Filter = (props) => {
  const {setFilter} = props

  return (
    <input onChange = {(e) => setFilter(e.target.value) }></input>
  )
}

export default Filter