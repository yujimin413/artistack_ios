//
//  temp.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/20.
//

struct dataManager {
    static func getData(_ completion: @escaping (Int) -> Void) -> Void {
        //진짜 api
        let data = 3
        completion(data)
    }
}

func a(completion: @escaping (Int) -> Void) {
    //TODO: API 호출하고 response b한테 건내주고 싶어요
    // api call
    dataManager.getData(completion)
}

func b(data: Int) {
    a { data in
        // data -> 3
        b(data: data)
    }
}
