import Foundation

protocol DockListController {
    func didTapDock(at id: UUID)
    func didTapRemoveButton(at id: UUID)
    func didTapAddButton()
}

class DockListControllerImpl: DockListController {
    private let customizeDockIconModulesModifier: CustomizeDockIconModulesModifier

    init(customizeDockIconModulesModifier: CustomizeDockIconModulesModifier) {
        self.customizeDockIconModulesModifier = customizeDockIconModulesModifier
    }
    
    func didTapDock(at id: UUID) {
        customizeDockIconModulesModifier.editCustomizeDockIconModule(at: id)
    }

    func didTapRemoveButton(at id: UUID) {
        customizeDockIconModulesModifier.removeCustomizeDockIconModule(at: id)
    }

    func didTapAddButton() {
        customizeDockIconModulesModifier.addNewCustomizeDockIconModule()
    }


}
