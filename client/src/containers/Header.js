import React from 'react'
import Delete from './Delete'
import Search from './Search'


const Header = () => {
  return(
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/applied">Applied</a></li>
      <li><a href="/locations">Locations</a></li>
      <li><a href="/keywords">Keywords</a></li>
      <Delete/>
      <Search/>
    </ul>
  )
}

export default Header