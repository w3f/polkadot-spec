import { tutorialSidebar } from `../sidebars.js`;
let sidebarRoutes = [];
for (let item of tutorialSidebar) {
    if (item.type === 'doc') {
        sidebarRoutes.push(item.id);
    } else if (item.type === 'category') {
        sidebarRoutes.push(item.link.id);
        for (let subItem of item.items) {
        sidebarRoutes.push(subItem.id);
        }
    }
}
export default sidebarRoutes;