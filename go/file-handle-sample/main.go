//
// file-handle-sample
//

package main

import (
    "fmt"
    "os"
)

func main() {
	// Mkdir
    if err := os.Mkdir("hoge", 0777); err != nil {
        fmt.Println(err)
    }

    // MkdirAll
    if err := os.MkdirAll("hoge/fuga", 0777); err != nil {
        fmt.Println(err)
    }

    // Rename
    if err := os.Rename("hoge/fuga", "hoge/mogu"); err != nil {
        fmt.Println(err)
    }

    // Chmod
    if err := os.Chmod("hoge", 0775); err != nil {
        fmt.Println(err)
    }

    // Remove
    os.Mkdir("gohe", 0777)
    if err := os.Remove("gohe"); err != nil {
        fmt.Println(err)
    }

    // RemoveAll
    os.MkdirAll("gohe/nofu", 0777)
    if err := os.RemoveAll("gohe"); err != nil {
        fmt.Println(err)
    }

    // Stat (File Exist)
    _, err := os.Stat("hoge.txt")
    if err == nil {
        fmt.Println(err)
    }

    fmt.Println( "file-handle-sample done." )
}