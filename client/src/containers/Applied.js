import React, {useState, useEffect} from 'react'
import Filter from './Filter'

const Applied = () => {

  const [postings, setPostings] = useState([])
  const [filter, setFilter] = useState(null)

  useEffect(() => {
      fetch("http://localhost:3000/applied_postings")
        .then(resp => resp.json())
        .then(json => setPostings(json))
    

  }, [])

  const renderRow = posting => {
    return(
      <tr>
        <td>{posting.company}</td>
        <td>{posting.title}</td>
        <td>{posting.city +" "+posting.state}</td>
        <td>{posting.updated_at}</td>
      </tr>
    )
  }

  const filterPostings = () => {
    if (!filter){
      return postings
    }
    else{
      debugger
      return postings.filter(posting => posting.title.toLowerCase().includes(filter.toLowerCase()) || posting.company.toLowerCase().includes(filter.toLowerCase()) )
    }
  }

  return(
    <>
    <Filter setFilter = {setFilter}/>
    <table>
      <tr>
        <th>Company</th>
        <th>Position</th>
        <th>City</th>
        <th>Date Applied</th>
      </tr>
      {filterPostings().map(posting => renderRow(posting))}
    </table>
    </>
  )
}

export default Applied