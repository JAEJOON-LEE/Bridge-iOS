//
//  GeneralPostViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/08.
//

import Foundation

final class GeneralPostViewModel : ObservableObject {
    let postList : PostList
    
    init(postList : PostList) {
        self.postList = postList
    }
    
    var imageUrl : String { postList.postInfo.image }
    var postTitle : String { postList.postInfo.title }
    var likeCount : Int { postList.postInfo.likeCount }
    var commentCount : Int { postList.postInfo.commentCount }
    var anonymous : Bool { postList.postInfo.anonymous }
    var postId : Int { postList.postInfo.postId }
    var description : String { postList.postInfo.description }
    var createdAt : String { postList.postInfo.createdAt }
    var profileImage : String { postList.member?.profileImage ?? "nil"}
    var userName : String { postList.member?.username ?? "nil" }
}
