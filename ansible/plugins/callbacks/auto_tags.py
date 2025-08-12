from ansible.plugins.callback import CallbackBase

# Based on https://gist.github.com/rkrzr/f5387167fa7b4869e2dca8b713879562
class CallbackModule(CallbackBase):

    def v2_playbook_on_start(self, playbook):
        for play in playbook.get_plays():
            self.tag_roles(play.get_roles())

    def tag_roles(self, roles):
        for role in roles:
            self.tag_role(role)
            self.tag_roles(role.get_direct_dependencies())

    def tag_role(self, role):
        role_name = role._role_name
        if role_name not in role.tags:
            role.tags += [role_name]
