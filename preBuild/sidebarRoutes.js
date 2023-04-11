const sidebars = require('../sidebars.js');
let sidebarRoutes = [];
for (let item of sidebars.tutorialSidebar) {
    if (item.type === 'doc') {
        sidebarRoutes.push({
            id: item.id,
            label: item.label,
            level: 0,
        });
    } else if (item.type === 'category') {
        sidebarRoutes.push({
            id: item.link.id,
            label: item.label,
            level: 0,
        });
        for (let subItem of item.items) {
            sidebarRoutes.push({
                id: subItem.id,
                label: subItem.label,
                level: 1,
            });
        }
    }
}
module.exports = sidebarRoutes;