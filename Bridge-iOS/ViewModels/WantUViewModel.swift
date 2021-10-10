//
//  WantUViewModel.swift
//  Bridge-iOS
//
//  Created by 이재준 on 2021/10/10.
//

import Foundation

final class WantUViewModel : ObservableObject {
    let postList : WantUPostList
//    let member : PostMember
    
    init(postList : WantUPostList) {
        self.postList = postList
//        self.member = member
    }
    
    var imageUrl : String { postList.postInfo.image }
    var postTitle : String { postList.postInfo.title }
    var likeCount : Int { postList.postInfo.likeCount }
    var commentCount : Int { postList.postInfo.commentCount }
    var postId : Int { postList.postInfo.postId }
    var description : String { postList.postInfo.description }
    var createdAt : String { postList.postInfo.createdAt }
    var profileImage : String { postList.member?.profileImage ?? "nil"}
    var userName : String { postList.member?.username ?? "nil" }
}
