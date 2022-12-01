<#

*** This is a very basic example of a switch I found online. Keeping it here for reference. ***

$day = 3

    switch ( $day )
    {
        0 { $result = 'Sunday'    }
        1 { $result = 'Monday'    }
        2 { $result = 'Tuesday'   }
        3 { $result = 'Wednesday' }
        4 { $result = 'Thursday'  }
        5 { $result = 'Friday'    }
        6 { $result = 'Saturday'  }
    }

    $result
#>

$var = Read-host -Prompt "Please enter Windows or IPTables"