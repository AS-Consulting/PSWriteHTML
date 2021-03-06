Import-Module "..\PSWriteHTML\PSWriteHTML.psd1" -Force

$DomainAdminTable = Get-ADForest | Select-Object ForestMode, Name, RootDomain, SchemaMaster
$EnterpriseAdminTable = Get-ADuser -Filter * | Select-Object Name, Surname, Enabled, DisplayName
$Allusers = Get-AdUser -Filter *

$HTMLPath = "$PSScriptRoot\Example5.html"

# Code Block for PowerShell Code (Showing how <pre> tags work)
$CodeBlock = @'

$HTML = New-HtmlPage -Name 'Test' -UseCssLinks -UseStyleLinks {
    New-HTMLTabHeader -TabNames 'Dashboard', 'Other'
    New-HTMLTab -TabName 'Dashboard' {
        New-HTMLContent -HeaderText 'Content' {
            New-HTMLColumn -ColumnNumber 1 -ColumnCount 2 {
                New-HTMLContent -HeaderText 'My text' -CanCollapse {
                    Get-HTMLContentTable -ArrayOfObjects $DomainAdminTable
                }
            }
            New-HTMLColumn -ColumnNumber 2 -ColumnCount 2 {
                New-HTMLContent -HeaderText 'My text' -CanCollapse {
                    Get-HTMLContentTable -ArrayOfObjects $DomainAdminTable
                }
            }
            New-HTMLContent -HeaderText 'My text 2' -CanCollapse {
                Get-HTMLContentDataTable -ArrayOfObjects $EnterpriseAdminTable
            }
        }
        New-HTMLContent -HeaderText 'This shows PowerShell Language' {
            Get-HTMLCodeBlock -Code $CodeBlock -Style 'PowerShell'
        }
    }
    New-HTMLTab -TabName 'Other' -TabHeading 'Test 2' {
        New-HTMLContent -HeaderText 'My other text' {
            Get-HTMLContentTable -ArrayOfObjects $EnterpriseAdminTable
        }
    }
}
Save-HTML -FilePath $HTMLPath -ShowHTML -HTML $HTML

'@

# Code Block for JS Code (Showing how <pre> tags work)
$CodeBlockJS = @'
//refresh page on browser resize
$(window).bind("resize", function(e) {
    if (window.RT) clearTimeout(window.RT);
    window.RT = setTimeout(function() {
        this.location.reload(false); /* false to get page from cache */
    }, 200);
});
'@

# Code Block for XML Code (Showing how <pre> tags work)
$CodeBlocksXML = @'
<!--?xml version="1.0" encoding="UTF-8"?-->
<building name="GlobalDynamics Main Building"
    core:id="0xFA8A91C6617DFA1B" core:uid="0898213-123123123-1230898123" xmlns:core="http://www.xmlnamespace.tld">
  <core:group core:level="2">
    <room number="123">Conference Room A</room>
    <room number="124">Conference Room B</room>
    <room number="125">Conference Room C</room>
    <room number="126">Conference Room D</room>
  </core:group>
  <core:group core:level="2">
    <room number="17">John's Office</room>
            <room number="19">Eric's Office</room>
  </core:group>
  <core:group core:level="1">
    <room number="091">Mainframe Housing A</room>
    <room number="092">Mainframe Housing B</room>
    <room number="090">Mainframe Power Supply Station</room>
    <room number="089">Mainframe Backup Power Supply Station</room>
  </core:group>
  <core:group core:level="8">
    <room number="1717" role="cto">CTO Office</room>
    <room number="1819" role="ceo">CEO Office</room>
    <room number="1820" role="cfo">
      <x_room label="k89121">Lab01</x_room>
    </room>
  </core:group>
</building>
'@

$HTML = New-Html -UseCssLinks -UseStyleLinks {
    New-HTMLTabHeader -TabNames 'Dashboard', 'Other'
    New-HTMLTab -TabName 'Dashboard' {
        New-HTMLContent -HeaderText 'Content' {
            New-HTMLColumn -ColumnNumber 1 -ColumnCount 2 {
                New-HTMLContent -HeaderText 'My text' -CanCollapse {
                    Get-HTMLContentTable -DataTable $DomainAdminTable
                }
            }
            New-HTMLColumn -ColumnNumber 2 -ColumnCount 2 {
                New-HTMLContent -HeaderText 'My text' -CanCollapse {
                    Get-HTMLContentTable -DataTable $DomainAdminTable
                }
            }
            New-HTMLContent -HeaderText 'My text 2' -CanCollapse {
                Get-HTMLContentDataTable -DataTable $EnterpriseAdminTable
            }
        }
        New-HTMLContent -HeaderText 'This shows PowerShell Language' {
            New-HTMLCodeBlock -Code $CodeBlock -Style 'PowerShell' -Group 'Test123' -Title 'PowerShell Code 1' -Theme godzilla -Highlight '2-5, 13'
            New-HTMLCodeBlock -Code $CodeBlock -Style 'PowerShell' -Group 'Test123' -Title 'PowerShell Code 2'
        }
        New-HTMLContent -HeaderText 'This shows PowerShell Language' {
            New-HTMLCodeBlock -Code $CodeBlockJS -Style 'JavaScript' -Theme enlighter -Highlight '2, 5'
        }
        New-HTMLContent -HeaderText 'XML Language' {
            New-HTMLCodeBlock -Code $CodeBlocksXML -Style 'xml' -Highlight '12, 19'
        }
    }
    New-HTMLTab -TabName 'Other' -TabHeading 'Test 2' {
        New-HTMLContent -HeaderText 'My other text' {
            Get-HTMLContentTable -DataTable $EnterpriseAdminTable
        }
    }
}
Save-HTML -FilePath $HTMLPath -ShowHTML -HTML $HTML