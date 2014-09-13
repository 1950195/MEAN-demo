config      = require '../config/sys.json'
locale      = require '../config/' + config.locale + '.json'
hbs         =
    user                        :
        pageHeader              : locale['user-management-page-header']
        _id                     : locale['id']
        username                : locale['username']
        password                : locale['password']
        name                    : locale['name']
        userGroup               : locale['user-group']
        deal                    : locale['deal']
        visitor                 :
            name                : locale['visitor-name']
            phone               : locale['visitor-phone']
            carInfo             :
                carBrand        : locale['visitor-car-brand']
                carSeries       : locale['visitor-car-series']
                price           : locale['visitor-car-price']
        enable                  : locale['enable']
        enableTrue              : locale['enable-true']
        enableFalse             : locale['enable-false']
        deletableTrue           : locale['deletable-true']
        deletableFalse          : locale['deletable-false']
        btnAdd                  : locale['btn-add-user']
        btnSubmit               : locale['btn-submit']
        btnCancel               : locale['btn-cancel']
        btnEdit                 : locale['btn-update']
        btnRemove               : locale['btn-remove']
        removeConfirm           : locale['confirm-remove']
        userForm                :
            add                 : locale['add-user-form']
            update              : locale['update-user-form']
        placeholder             :
            name                : locale['placeholder-name']
            username            : locale['placeholder-username']
            password            : locale['placeholder-password']
            userGroup           : locale['placeholder-user-group-name']
            deal                : locale['placeholder-deal-name']
            visitor             :
                name            : locale['placeholder-visitor-name']
                phone           : locale['placeholder-visitor-phone']
                carInfo         :
                    carBrand    : locale['placeholder-visitor-car-brand']
                    carSeries   : locale['placeholder-visitor-car-series']
                    price       : locale['placeholder-visitor-car-price']
        tpl                     :
            errorMsg            : '{{errorMsg}}'
            _id                 : '{{user._id}}'
            name                : '{{user.name}}'
            username            : '{{user.username}}'
            password            : '{{user.password}}'
            userGroup           : '{{user.userGroup.name}}'
            deal                : '{{user.deal.name}}'
            visitor             :
                name            : '{{user.visitor.name}}'
                phone           : '{{user.visitor.phone}}'
                carInfo         :
                    carBrand    : '{{user.visitor.carInfo.carBrand}}'
                    carSeries   : '{{user.visitor.carInfo.carSeries}}'
                    price       : '{{user.visitor.carInfo.price}}'
            enable              : '{{user.enable ? \'' + locale['enable-true'] + '\' : \'' + locale['enable-false'] + '\'}}'
            deletable           : '{{user.deletable}}'
            selected            : '{{$select.selected.name}}'
    userGroup                   :
        pageHeader              : locale['user-group-management-page-header']
        _id                     : locale['user-group-id']
        level                   : locale['user-group-value']
        name                    : locale['user-group-name']
        deletableTrue           : locale['deletable-true']
        deletableFalse          : locale['deletable-false']
        btnAdd                  : locale['btn-add-user-group']
        btnSubmit               : locale['btn-submit']
        btnCancel               : locale['btn-cancel']
        btnEdit                 : locale['btn-update']
        btnRemove               : locale['btn-remove']
        removeConfirm           : locale['confirm-remove']
        userGroupForm           :
            add                 : locale['add-user-group-form']
            update              : locale['update-user-group-form']
        placeholder             :
            level               : locale['placeholder-user-group']
            name                : locale['placeholder-user-group-name']
        tpl                     :
            errorMsg            : '{{errorMsg}}'
            _id                 : '{{userGroup._id}}'
            level               : '{{userGroup.level}}'
            name                : '{{userGroup.name}}'
            deletable           : '{{userGroup.deletable}}'

module.exports =
    user: (req, res) ->
        res.render 'partials/user.main.hbs', hbs.user

    userGroup: (req, res) ->
        res.render 'partials/user_group.main.hbs', hbs.userGroup
