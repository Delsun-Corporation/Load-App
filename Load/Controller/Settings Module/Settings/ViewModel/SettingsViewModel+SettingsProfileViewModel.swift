//
//  SettingsViewModel+SettingsProfileViewModel.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 21/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

extension SettingsViewModel: SettingProfileViewModelDelegate {
    func refreshDataAfterUpdateProfile() {
        theController.mainView.tableView.reloadData()
    }
}
