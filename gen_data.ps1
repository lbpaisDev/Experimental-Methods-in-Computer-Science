#Check if there's ./data folder
$path_exist = Test-Path -Path "./data"
if (!$path_exist) {
    #If not create it
    New-Item -Path "./data" -ItemType Directory
}

#Start at a colision prob of 40%
$p = 0.40
#Go until 70%
#i is the test group Id
For ($i = 0; $p -le 0.55; $i++) {
	$n = 25
        #j is the number of tests per combination
        For ($j = 0; $j -lt 100; $j++) {
            #Get a random value for the seed
            $s = Get-Random -Minimum 10000 -Maximum 99999
            #Set test file name with usefull information
            $file_name = "test_" + $i + "_" + $n + "_" + $p + "_" + $s + ".in"
            #Use provided script to generate test cases
            python gen.py $n $p $s $file_name
            #Move generated test to the goal directory
            Move-Item -Path $file_name -Destination "./data"
        }
    #Increase prob with a step of 5%  
    $p = $p + 0.05    
}
